import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { statusCode } from "../domain/enums/statusCode.enum";
import { createResponse } from "../factory/response.factory";

export const createEvent = async (
  event: APIGatewayProxyEvent = {}
): Promise<APIGatewayProxyResult> => {
  
  return createResponse({
    code: statusCode.ok,
    headers: event.headers,
    body: {
      response:
        "Welcome to the terraform-lambda API, here are the details of your request:",
      headers: event.headers,
      method: event.httpMethod,
      body: event.body,
    },
  });
};
