class ProgressChannel < ApplicationCable::Channel
  def subscribed
    stream_from "progress_channel"
  end

  def unsubscribed
    # Cleanup when channel is unsubscribed
  end
end
