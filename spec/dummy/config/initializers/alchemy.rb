# frozen_string_literal: true

Rails.application.config.to_prepare do
  Alchemy.register_ability Ability
  Alchemy.user_class_name = "DummyUser"
  Alchemy.signup_path = "/admin/pages" unless Rails.env.test?
  Alchemy::Modules.register_module(
    name: "events",
    navigation: {
      name: "Events",
      controller: "/admin/events",
      action: "index",
      icon: "calendar-event-line",
      sub_navigation: [{
        name: "Events",
        controller: "/admin/events",
        action: "index"
      }, {
        name: "Locations",
        controller: "/admin/locations",
        action: "index"
      }, {
        name: "Series",
        controller: "/admin/series",
        action: "index"
      }, {
        name: "Bookings",
        controller: "/admin/bookings",
        action: "index"
      }]
    }
  )
end
