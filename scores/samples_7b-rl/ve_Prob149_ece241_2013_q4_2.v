
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] fr_reg;
    reg dfr_reg;
    reg [2:0] prev_s;

    
    assign fr2 = fr_reg[2];
    assign fr1 = fr_reg[1];
    assign fr0 = fr_reg[0];
    assign dfr = dfr_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            fr_reg <= 3'b111;
            dfr_reg <= 1'b1;
            prev_s <= 3'b000;
        end
        else begin
            prev_s <= s;

            if (s == 3'b111) begin  
                fr_reg <= 3'b000;
                dfr_reg <= 1'b0;
            end
            else if (s == 3'b000) begin 
                fr_reg <= 3'b111;
                dfr_reg <= 1'b1;
            end
            else begin
                
                case (1'b1)
                    (s == 3'b110): begin 
                        fr_reg <= 3'b001;
                        dfr_reg <= (prev_s < s);
                    end
                    (s == 3'b011 || s == 3'b101): begin 
                        fr_reg <= 3'b011;
                        dfr_reg <= (prev_s < s);
                    end
                    default: begin 
                        fr_reg <= 3'b000;
                        dfr_reg <= 1'b0;
                    end
                endcase
            end
        end
    end

endmodule
