# class CloudWatch
class CloudWatch
  def get_metric_statistics(start_time, end_time)
    cw.get_metric_statistics(
      namespace: 'AWS/Billing',
      metric_name: 'EstimatedCharges',
      dimensions: [
        {
          name: 'Currency',
          value: 'USD'
        }
      ],
      start_time: start_time,
      end_time: end_time,
      period: 60,
      statistics: [
        'Maximum'
      ]
    )
  end

  private

  def cw
    @cw ||= Aws::CloudWatch::Client.new
  end
end
