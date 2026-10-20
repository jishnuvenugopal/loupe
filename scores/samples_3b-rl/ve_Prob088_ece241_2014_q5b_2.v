
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    
    reg [1:0] state;

    
    
    
    
    

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (x == 1'b0) begin
                        state <= 2'b00;
 
                        z <= 1'b0;
                    end else begin
                        state <= 2'b01;
 
                        z <= 1'b1;
                    end
                end
                2'b01: begin 
                    if (x == 1'b0) begin
                        state <= 2'b01;
 
                        z <= 1'b1;
                    end else begin
                        state <= 2'b00;
 
                        z <= 1'b0;
                    end
                end
                default: begin
                    state <= 2'b00;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
