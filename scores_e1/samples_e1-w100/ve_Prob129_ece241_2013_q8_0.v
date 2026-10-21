
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    reg [1:0] state;
    reg [1:0] next_state;

    
    reg [1:0] output;

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            state <= 2'b00;
            output <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (x == 1'b1) begin
                        next_state <= 2'b01;
                    end else begin
                        next_state <= 2'b00;
                    end
                end
                2'b01: begin
                    if (x == 1'b0) begin
                        next_state <= 2'b02;
                    end else begin
                        next_state <= 2'b01;
                    end
                end
                2'b02: begin
                    if (x == 1'b1) begin
                        next_state <= 2'b03;
                    end else begin
                        next_state <= 2'b02;
                    end
                end
                2'b03: begin
                    next_state <= 2'b00;
                    z <= 1'b1;
                end
            endcase
            state <= next_state;
        end
    end

    
    always @(posedge clk or posedge aresetn) begin
        if (aresetn) begin
            output <= 2'b00;
        end else begin
            output <= state;
        end
    end

endmodule
