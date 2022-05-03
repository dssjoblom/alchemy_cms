# frozen_string_literal: true
module Alchemy
  class Engine < Rails::Engine
    isolate_namespace Alchemy
    engine_name "alchemy"
    config.mount_at = "/"

    initializer "alchemy.lookup_context" do
      config.to_prepare do
        unless defined? Alchemy::LOOKUP_CONTEXT
          Alchemy::LOOKUP_CONTEXT = ActionView::LookupContext.new(Rails.root.join("app", "views", "alchemy"))
        end
      end
    end

    initializer "alchemy.dependency_tracker" do
      config.to_prepare do
        [:erb, :slim, :haml].each do |handler|
          ActionView::DependencyTracker.register_tracker(handler, CacheDigests::TemplateTracker)
        end
      end
    end

    initializer "alchemy.non_digest_assets" do
      config.to_prepare do
        NonStupidDigestAssets.whitelist += [/^tinymce\//]
      end
    end

    # Gutentag downcases all tags before save
    # and Gutentag validations are not case sensitive.
    # But we support having tags with uppercase characters.
    config.to_prepare do
      Gutentag.normaliser = ->(value) { value.to_s }
      Gutentag.tag_validations = Alchemy::TagValidations
    end

    # Custom Ransack sort arrows
    initializer "alchemy.ransack" do
      config.to_prepare do
        Ransack.configure do |config|
          config.custom_arrows = {
            up_arrow: '<i class="fa fas fa-xs fa-arrow-up"></i>',
            down_arrow: '<i class="fa fas fa-xs fa-arrow-down"></i>',
          }
        end
      end
    end

    initializer "alchemy.userstamp" do
      config.to_prepare do
        ActiveSupport.on_load(:active_record) do
          if Alchemy.user_class
            Alchemy.user_class.model_stamper
            Alchemy.user_class.stampable(stamper_class_name: Alchemy.user_class.name)
          end
        end
      end
    end
  end
end
