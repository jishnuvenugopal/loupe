
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    
    reg [3:0] counter = 4'b0001;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0001;
 
        end else begin
            
            if (counter == 4'b0010) begin
                counter <= 4'b0011;
            end else if (counter == 4'b0011) begin
                counter <= 4'b0100;
            end else if (counter == 4'b0100) begin
                counter <= 4'b0101;
            end else if (counter == 4'b0101) begin
                counter <= 4'b0110;
            end else if (counter == 4'b0110) begin
                counter <= 4'b0111;
            end else if (counter == 4'b0111) begin
                counter <= 4'b1000;
            end else if (counter == 4'b1000) begin
                counter <= 4'b1001;
            end else if (counter == 4'b1001) begin
                counter <= 4'b1010;
            end else if (counter == 4'b1010) begin
                counter <= 4'b1011;
            end else if (counter == 4'b1011) begin
                counter <= 4'b1100;
            end else if (counter == 4'b1100) begin
                counter <= 4'b1101;
            end else if (counter == 4'b1101) begin
                counter <= 4'b1110;
            end else if (counter == 4'b1110) begin
                counter <= 4'b1111;
            end else if (counter == 4'b1111) begin
                counter <= 4'b0001;
 
            end
        end
    end

    assign q = counter;

endmodule
