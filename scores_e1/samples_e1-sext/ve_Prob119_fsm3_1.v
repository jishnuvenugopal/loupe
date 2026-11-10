
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg [1:0] state;
    reg next_state;

    
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            next_state = state;
            case (state)
                2'b00: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b01;
 
                    end else begin
                        next_state <= 2'b00;
 
                    end
                end
                2'b01: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b00;
 
                    end else begin
                        next_state <= 2'b10;
 
                    end
                end
                2'b10: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b11;
 
                    end else begin
                        next_state <= 2'b10;
 
                    end
                end
                2'b11: begin
                    if (in == 1'b0) begin
                        next_state <= 2'b00;
 
                    end else begin
                        next_state <= 2'b11;
 
                    end
                end
            endcase
        end
    end

    
    assign out = state[0];

endmodule
