
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    reg [1:0] state;
    reg [1:0] w_count;
 

    
    reg z_reg;

    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            w_count <= 2'b00;
            z_reg <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (s == 1'b1) begin
                        state <= 2'b01;
 
                    end
                    w_count <= 2'b00;
                    z_reg <= 1'b0;
                end
                2'b01: begin 
                    if (w_count == 2'b00) begin
                        w_count <= 2'b01;
 
                    end else if (w_count == 2'b01) begin
                        if (w == 1'b1) begin
                            w_count <= 2'b10;
 
                        end else begin
                            w_count <= 2'b00;
 
                        end
                    end else if (w_count == 2'b10) begin
                        if (w == 1'b1) begin
                            w_count <= 2'b11;
 
                        end else begin
                            w_count <= 2'b00;
 
                        end
                    end else begin
                        if (w == 1'b1) begin
                            w_count <= 2'b00;
 
                        end else begin
                            w_count <= 2'b00;
 
                        end
                    end
                    if (w_count == 2'b11) begin
                        z_reg <= 1'b1;
 
                    end else begin
                        z_reg <= 1'b0;
                    end
                    if (w_count == 2'b11) begin
                        state <= 2'b00;
 
                    end
                end
                default: begin
                    state <= 2'b00;
                    w_count <= 2'b00;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        z <= z_reg;
    end

endmodule
