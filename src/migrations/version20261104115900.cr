class Vox::Migrations::Version20261104115900 < AORM::Migrations::AbstractMigration
  def description : String
    "Initialize the SQLite database (users, conversations and messages)"
  end

  def up : Nil
    self.add_sql <<-SQL
    CREATE TABLE IF NOT EXISTS `users` (
      `id` INTEGER PRIMARY KEY AUTOINCREMENT,
      `username` VARCHAR(255) NOT NULL,
      `password` VARCHAR(255) NOT NULL,
      `api_token` VARCHAR(255) NOT NULL,
      `created_at` DATETIME NOT NULL,
      `updated_at` DATETIME NOT NULL
    );
    SQL

    self.add_sql <<-SQL
    CREATE TABLE IF NOT EXISTS `users_conversations` (
      `user_id` INTEGER NOT NULL,
      `conversation_id` INTEGER NOT NULL,

      FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
      FOREIGN KEY(`conversation_id`) REFERENCES `users`(`id`)
    );
    SQL

    self.add_sql <<-SQL
    CREATE TABLE IF NOT EXISTS `conversations` (
      `id` INTEGER PRIMARY KEY AUTOINCREMENT,
      `created_at` DATETIME NOT NULL,
      `updated_at` DATETIME NOT NULL
    );
    SQL

    self.add_sql <<-SQL
    CREATE TABLE IF NOT EXISTS `messages` (
      `id` INTEGER PRIMARY KEY AUTOINCREMENT,
      `message` TEXT NOT NULL,
      `user_id` INTEGER NOT NULL,
      `conversation_id` INTEGER NOT NULL,
      `sent_at` DATETIME NOT NULL,

      FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
      FOREIGN KEY(`conversation_id`) REFERENCES `conversations`(`id`)
    );
    SQL
  end

  def down : Nil
    self.add_sql "DROP TABLE IF EXISTS `conversations`;"
    self.add_sql "DROP TABLE IF EXISTS `users_conversations`;"
    self.add_sql "DROP TABLE IF EXISTS `users`;"
  end
end
