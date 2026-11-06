Athena::Dotenv.load

ATH.configure({
  framework: {
    file_uploads: {
      enabled: true,
    },
  },
  orm: {
    url:        ENV["DATABASE_URL"],
    migrations: {
      namespace: "Vox::Migrations",
      directory: "#{__DIR__}/migrations",
    },
  },
  security: {
    password_hashers: {
      Vox::Entities::User => :auto,
    },
    providers: {
      app_users: {id: "vox_user_provider"},
    },
    firewalls: {
      api: {
        pattern:               /^\/api/,
        custom_authenticators: ["vox_api_token_authenticator"],
      },
      auth_login: {
        pattern:               /\/auth\/login/,
        custom_authenticators: ["vox_password_authenticator"],
      },
    },
    access_control: [
      {path: /^\/api/, role: "IS_AUTHENTICATED"},
      {path: /^\/auth/, role: "PUBLIC_ACCESS"},
    ],
  },
})
