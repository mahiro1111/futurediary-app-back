class Realdiary < ApplicationRecord
  belongs_to :user

  # 日記の作成や更新時に、モデルで設定したバリデーションが自動的に実行
  # validates :title, presence: true
  # validates :diary, presence: true
  # validates :date, presence: true
  # validates :user_id, presence: true
  validates_presence_of :title, :diary, :date, :user_id

  # リアル日記作成or更新メソッド
  def self.find_or_create_or_update(params)
    real_diary = find_or_initialize_by(user_id: params[:user_id], date: params[:date])

    if real_diary.update(params)
      message = real_diary.persisted? ? "日記を更新しました。" : "日記を新規作成しました。"
      { success: true, message: message }
    else
      { success: false, errors: real_diary.errors.full_message }
    end
  end
end
