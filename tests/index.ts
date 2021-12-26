import { expect } from "chai";
import lambdaTester from "lambda-tester";
import * as lambda from "../src";
import { responseHeaders } from "../src/domain/constants/headers.constant";

const mockData = {
  headers: responseHeaders,
  httpMethod: "POST",
  body: { username: "xyz", password: "xyz" },
};

const mockData1 = {
  headers: responseHeaders,
  httpMethod: "GET",
  body: { username: "xyz", password: "xyz" },
};

describe("EVENT TESTS", () => {
  it("should return a successful result: POST", async () => {
    await lambdaTester(lambda.createEvent)
      .event(mockData)
      .expectResult((result) => {
        expect(result.statusCode).to.eql(200);

        const body = result.body;

        expect(body.response).to.eql(
          "Welcome to terraform-lambda API, here are the details of your request:"
        );
        expect(body.method).to.eql("POST");
      });
  });

  it("should return a successful result: GET", async () => {
    await lambdaTester(lambda.getEvent)
      .event(mockData1)
      .expectResult((result) => {
        expect(result.statusCode).to.eql(200);

        const body = result.body;

        expect(body.response).to.eql(
          "Welcome to terraform-lambda API, here are the details of your request:"
        );
        expect(body.method).to.eql("GET");
      });
  });
});
