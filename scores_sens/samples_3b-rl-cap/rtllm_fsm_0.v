
module fsm (
    input        CLK,
    input        RST,
    input        IN,
    output reg   MATCH
);

    
    
    
    
    
    
    reg [3:0] state;

    
    reg [4:0] input_seq;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state   <= 4'b0000;
            input_seq <= 5'b00000;
            MATCH <= 1'b0;
        end else begin
            
            input_seq <= {input_seq[3:0], IN};

            case (state)
                4'b0000: begin 
                    if (IN == 1'b1) begin
                        state <= 4'b0001;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0001: begin 
                    if (IN == 1'b0) begin
                        state <= 4'b0010;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0010: begin 
                    if (IN == 1'b0) begin
                        state <= 4'b0011;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0011: begin 
                    if (IN == 1'b1) begin
                        state <= 4'b0100;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0100: begin 
                    if (IN == 1'b1) begin
                        state <= 4'b0101;
                        MATCH <= 1'b1;
                    end else begin
                        state <= 4'b0000;
                        MATCH <= 1'b0;
                    end
                end
                4'b0101: begin 
                    if (IN == 1'b1) begin
                        state <= 4'b0101;
                        MATCH <= 1'b1;
                    end else begin
                        state <= 4'b0000;
                        MATCH <= 1'b0;
                    end
                end
                default: begin
                    state <= 4'b0000;
                    MATCH <= 1'b0;
                end
            endcase
        end
    end

    
    
    assign MATCH = state == 4'b0101 ? 1'b1 : 1'b0;

endmodule
