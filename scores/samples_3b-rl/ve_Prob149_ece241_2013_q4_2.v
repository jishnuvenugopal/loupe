
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [2:0] s,
    output reg  fr2,
    output reg  fr1,
    output reg  fr0,
    output reg  dfr
);

    
    reg [2:0] prev_s;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
            prev_s <= 3'b000;
        end else begin
            
            if (s[2])
                fr2 <= 1'b0;
            else begin
                
                if (s[0])
                    fr2 <= 1'b1;
                else begin
                    
                    case ({s, prev_s})
                        
                        3'b111: fr2 <= 1'b0;
                        
                        3'b110: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b0;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                        
                        3'b101: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b1;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                        
                        3'b100: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b1;
                            fr2 <= 1'b1;
                            dfr <= 1'b0;
                        end
                        
                        3'b011: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b0;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                        
                        3'b010: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b0;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                        
                        3'b001: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b0;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                        
                        3'b000: begin
                            fr0 <= 1'b1;
                            fr1 <= 1'b1;
                            fr2 <= 1'b1;
                            dfr <= 1'b0;
                        end
                        default: begin
                            fr0 <= 1'b0;
                            fr1 <= 1'b0;
                            fr2 <= 1'b0;
                            dfr <= 1'b0;
                        end
                    endcase
                end
            end
            
            prev_s <= s;
        end
    end

endmodule
