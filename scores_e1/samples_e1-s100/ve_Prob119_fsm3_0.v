
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin
                    if (in == 0) state <= 2'b00;
 
                    else state <= 2'b01;
 
                end
                2'b01: begin
                    if (in == 0) state <= 2'b01;
 
                    else state <= 2'b10;
 
                end
                2'b10: begin
                    if (in == 0) state <= 2'b10;
 
                    else state <= 2'b11;
 
                end
                2'b11: begin
                    if (in == 0) state <= 2'b11;
 
                    else state <= 2'b00;
 
                end
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (areset) begin
            out <= 1'b0;
 
        end else begin
            out <= state[1];
 
        end
    end

endmodule
