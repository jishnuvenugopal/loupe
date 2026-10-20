
module TopModule (
    input        clk,
    input        aresetn,
    input        x,
    output reg   z
);

    
    reg [2:0] state;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 3'b000;
            z <= 1'b0;
        end else begin
            case (state)
                3'b000: state <= (x == 1'b0) ? 3'b001 : 3'b000;
                3'b001: state <= (x == 1'b0) ? 3'b010 : 3'b001;
                3'b010: state <= (x == 1'b1) ? 3'b010 : 3'b001;
                default: state <= 3'b000;
            endcase
            if (state == 3'b010)
                z <= 1'b1;
            else
                z <= 1'b0;
        end
    end

endmodule
