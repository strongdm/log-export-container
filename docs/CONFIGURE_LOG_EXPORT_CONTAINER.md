# Configure Log Export Container

## The container

### Required configuration
* **LOG_EXPORT_CONTAINER_INPUT**. Container input format (`json` or `csv`). Default: `json`
* **LOG_EXPORT_CONTAINER_OUTPUT**. Container output storage (`stdout` or `s3`). Default: `stdout`

### Optional configuration
#### S3
When using `LOG_EXPORT_CONTAINER_OUTPUT=s3` add variables listed in [CONFIGURE_S3.md](CONFIGURE_S3.md)

## SDM

The current version of the container only supports rsyslog, please refer to the image below to observe a typical configuration:

<img src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" data-canonical-src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" width="50%" height="50%" />
