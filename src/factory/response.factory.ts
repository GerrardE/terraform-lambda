import { responseHeaders } from "../domain/constants/headers.constant";
import { IResponse } from "../domain/interfaces/response.interface";

export const createResponse = ({
  code = 200,
  headers = responseHeaders,
  body = {},
}): IResponse => {
  return {
    statusCode: code,
    headers: headers,
    body,
  };
};
