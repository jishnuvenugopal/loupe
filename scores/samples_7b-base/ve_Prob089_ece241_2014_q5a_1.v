
module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    
    reg [3:0] state;
    reg [3:0] count;
    reg [3:0] temp;

    
    parameter IDLE = 4'b0000;
    parameter INPUT = 4'b0001;
    parameter COMPLEMENT = 4'b0010;
    parameter OUTPUT = 4'b0011;

    
    always @(posedge clk) begin
        if (areset) begin
            state <= IDLE;
            count <= 0;
            temp <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!areset)
                        state <= INPUT;
                end
                INPUT: begin
                    if (x) begin
                        temp <= temp << 1;
                        temp[0] <= x;
                        count <= count + 1;
                    end else begin
                        state <= COMPLEMENT;
                    end
                end
                COMPLEMENT: begin
                    temp <= ~temp;
                    temp <= temp + 1;
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    z <= temp[3];
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
