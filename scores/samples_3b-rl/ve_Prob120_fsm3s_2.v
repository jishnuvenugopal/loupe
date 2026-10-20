
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    reg [1:0] state;
    reg out;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                        out <= 1'b0;
                    end else begin
                        state <= 2'b01;
 
                        out <= 1'b0;
                    end
                end
                2'b01: begin 
                    if (in == 1'b0) begin
                        state <= 2'b10;
 
                        out <= 1'b0;
                    end else begin
                        state <= 2'b01;
 
                        out <= 1'b0;
                    end
                end
                2'b10: begin 
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                        out <= 1'b0;
                    end else begin
                        state <= 2'b11;
 
                        out <= 1'b0;
                    end
                end
                2'b11: begin 
                    state <= 2'b10;
 
                    out <= 1'b1;
                end
                default: begin
                    state <= 2'b00;
                    out <= 1'b0;
                end
            endcase
        end
    end

    assign out = out;

endmodule
