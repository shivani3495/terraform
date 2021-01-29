# ADD A LOCALS and put location in output path and filename
locals {
  lambda_zip_location = "outputs/welcome.zip"
}


# Archive a single file.

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name = "welcome"
  role          = aws_iam_role.lambda_role.arn
  handler       = "welcome.hello" # welcome is file and hello is method

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  
  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"

  
}

# first changes in the details above in resource
# next to create zip including welcome.py by using archieve file
# change filename to the same of output path
# if we make a change we have to made changes to both places
# to avoid this we declare locaLS. 