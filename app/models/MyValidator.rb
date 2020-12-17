class MyValidator < ActiveModel::Validator
    def validate(record)
        unless record.avatar_url.ends_with? '.jpg'
            record.errors[:avatar_url] << 'is incorrect. We require a JPG image for the Avatar url field please!'
        end
    end
end