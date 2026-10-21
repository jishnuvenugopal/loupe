
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
 
            data_out <= 1'b0;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (data_in == 1'b1) begin
                        state <= 2'b01;
 
                    end
                end
                2'b01: begin 
                    if (data_in == 1'b1) begin
                        state <= 2'b10;
 
                    end
                    else if (data_in == 1'b0) begin
                        state <= 2'b00;
 
                    end
                end
                2'b10: begin 
                    if (data_in == 1'b0) begin
                        state <= 2'b11;
 
                    end
                end
                2'b11: begin 
                    data_out <= 1'b1;
 
                    state <= 2'b00;
 
                end
            endcase
        end
    end

endmodule
