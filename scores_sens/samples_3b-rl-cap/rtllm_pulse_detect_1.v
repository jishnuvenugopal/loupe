
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    
    reg [4:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 5'b0;
            data_out <= 1'b0;
        end else begin
            
            state <= {state[3:0], data_in};

            
            if (state == 5'b01010) begin
                data_out <= 1'b1;
                state <= 5'b0;
 
            end else begin
                data_out <= 1'b0;
            end
        end
    end

endmodule
