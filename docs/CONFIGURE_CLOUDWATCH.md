# Configure AWS CloudWatch

The Log Export Container uses a [fluentd cloudwatch output plugin](https://github.com/fluent-plugins-nursery/fluent-plugin-cloudwatch-logs). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=cloudwatch` and provide the following variables:
* **AWS_ACCESS_KEY_ID**. AWS Access Key
* **AWS_SECRET_ACCESS_KEY**. AWS Access Secret
* **AWS_REGION**. AWS Region Name, for example: e.g. `us-west-2`
* **LOG_GROUP_NAME**. AWS CloudWatch Log Group Name to store logs: e.g. `aws/sdm-logs`
* **LOG_STREAM_NAME**. AWS CloudWatch log stream name to store logs, for example: e.g. `test`

## IAM permissions
Add -at least- the following policy to your IAM user:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

## Plugin changes

The cloudwatch output plugin supports multiple configurations. Please refer to [output-cloudwatch.conf](../fluentd/etc/output-cloudwatch.conf)

In case you want to specify different parameters and customize the output plugin, you could download [output-cloudwatch.conf](../fluentd/etc/output-cloudwatch.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-cloudwatch.conf:/fluentd/etc/output-cloudwatch.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=cloudwatch \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_REGION=$AWS_REGION \
  -e LOG_GROUP_NAME=$LOG_GROUP_NAME \
  -e LOG_STREAM_NAME=$LOG_STREAM_NAME log-export-container 
```
