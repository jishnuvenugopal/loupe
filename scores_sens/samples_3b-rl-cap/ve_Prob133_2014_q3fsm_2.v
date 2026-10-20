
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    reg [1:0] state;

    
    reg [2:0] w_count;

    
    reg z_reg;

    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            w_count <= 3'b000;
            z_reg <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (s == 1'b1) begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin 
                    if (w_count == 3'b000) begin
                        
                        w_count <= 3'b001;
                    end else begin
                        if (w_count < 3'b010) begin
                            w_count <= w_count + 1'b1;
                        end
                        if (w_count == 3'b010) begin
                            
                            if ((w_count[0] + w_count[1] + w_count[2]) == 2'b10) begin
                                z_reg <= 1'b1;
                            end else begin
                                z_reg <= 1'b0;
                            end
                            w_count <= 3'b000;
                        end
                    end
                end
                default: begin
                    state <= 2'b00;
                    w_count <= 3'b000;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule
