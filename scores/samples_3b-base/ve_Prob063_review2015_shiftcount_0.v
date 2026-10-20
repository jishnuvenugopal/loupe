
module TopModule (
    input  clk,
    input  shift_ena,
    input  count_ena,
    input  data,
    output reg [3:0] q
);

    
    reg [3:0] shift_register;
    reg [3:0] count_register;

    
    always @(posedge clk) begin
        if (shift_ena) begin
            
            shift_register <= {data, shift_register[3:1]};
        end
    end

    
    always @(posedge clk) begin
        if (count_ena) begin
            
            count_register <= count_register - 1;
        end
    end

    
    assign q = shift_register;

endmodule
