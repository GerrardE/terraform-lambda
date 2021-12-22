export type ResponseHeader = { [header: string]: string | number | boolean; }

export interface IResponse {
    statusCode: number;
    headers: ResponseHeader;
    body: string;
}
