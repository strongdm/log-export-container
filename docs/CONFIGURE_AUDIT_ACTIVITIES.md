# Configure Audit Activities

The Log Export Container uses [fluentd input exec plugin](https://docs.fluentd.org/input/exec) to input the activity logs from SDM CLI Audit.
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES=true` and provide the following variable:
* **SDM_ADMIN_TOKEN**. Admin Token created in SDM Web UI.
