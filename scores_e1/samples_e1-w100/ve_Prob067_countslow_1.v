
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    
    reg [3:0] counter;
    reg pause;

    
    reg [3:0] count_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0;
            pause <= 1'b0;
            count_reg <= 4'b0;
        end else begin
            if (pause) begin
                count_reg <= counter;
            end else begin
                counter <= counter + 1'b1;
                if (counter == 4'b9) begin
                    counter <= 4'b0;
                end
            end
        end
    end

    
    assign q = count_reg;

endmodule
