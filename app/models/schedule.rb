class Schedule < ApplicationRecord
	belongs_to :user

	class Schedule < ApplicationRecord
		belongs_to :user

		# Google Calendarからイベントを取得して保存するメソッド
		def self.save_google_calendar_events(user, date, token)
			service = Google::Apis::CalendarV3::CalendarService.new
			service.authorization = token

			start_time = DateTime.parse(date).beginning_of_day
			end_time = start_time.end_of_day

			events = service.list_events(
				'primary',
				time_min: start_time.iso8601,
				time_max: end_time.iso8601,
				single_events: true,
				order_by: 'startTime'
			)

			saved_events = []

			events.items.each do |event|
				schedule = Schedule.create(
					user: user,
					date: date,
					start_time: event.start.date_time,
					end_time: event.end.date_time,
					time_zone: event.start.time_zone || 'UTC',
					summary: event.summary
				)
				saved_events << schedule
			end

			saved_events
		end
	end
end
