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
        "Welcome to terraform-lambda API, here are the details of your request:",
      headers: event.headers,
      method: event.httpMethod,
      body: event.body,
    },
  });
};

export const getEvent = async (
  event: APIGatewayProxyEvent = {}
): Promise<APIGatewayProxyResult> => {
  return createResponse({
    code: statusCode.ok,
    body: {
      response:
        "Welcome to terraform-lambda API, here are the details of your request:",
      headers: event.headers["Content-Type"],
      method: event.httpMethod,
      body: event.body,
    },
  });
};
