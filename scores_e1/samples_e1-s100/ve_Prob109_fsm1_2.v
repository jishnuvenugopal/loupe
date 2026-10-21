
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    initial begin
        state = 2'b10;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10;
 
        end else begin
            case (state)
                2'b10: begin
                    if (in == 1'b0) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b11;
 
                    end
                end
                2'b00: begin
                    state <= 2'b01;
 
                end
                2'b11: begin
                    state <= 2'b10;
 
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
 
        end else begin
            out <= state[0];
 
        end
    end

endmodule
