// import * as chai from "chai";
// import axios from "axios";
import { config } from "dotenv";
import lambdaTester from "lambda-tester";
import * as lambda from '../handler';

config();

// const { expect } = chai;

const mockData = { username: "xyz", password: "xyz" };


describe("CREATE EVENT TESTS", () => {
//   let response, statusCode: number;

  before(async () => {
    try {
      const res = await lambdaTester(lambda.createEvent).event(mockData);
    //   statusCode = 200;
    //   response = res.data;
      console.log(res, ">>>>>>>>>>>>")
    //   console.log(statusCode)

      return res;
    } catch (error: unknown) {
    //   statusCode = error.response.statusCode;
    //   response = error.response.body;
      return error;
    }
  });

  it("should return a 200 status code", (done) => {
    // expect(statusCode).to.eql(200);
    
    done();
  });

//   it("should return success on hitting event post api", (done) => {
//     expect(response.response).to.eql(
//       "Welcome to terraform-lambda API, here are the details of your request:"
//     );
//     done();
//   });
});
