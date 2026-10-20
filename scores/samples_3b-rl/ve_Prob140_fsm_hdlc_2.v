
module TopModule (
    input        clk,
    input        reset,
    input        in,
    output reg   disc,
    output reg   flag,
    output reg   err
);

    
    reg [6:0] state;

    
    always @(posedge clk) begin
        if (reset) begin
            state   <= 7'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            
            state   <= {state[5:0], in};

            
            if (state == 7'b1111110) begin
                disc    <= 1'b1;
                flag    <= 1'b0;
                err     <= 1'b0;
            end else if (state == 7'b11111110) begin
                flag    <= 1'b1;
                disc    <= 1'b0;
                err     <= 1'b0;
            end else if (state == 7'b11111111) begin
                err     <= 1'b1;
                disc    <= 1'b0;
                flag    <= 1'b0;
            end else begin
                disc    <= 1'b0;
                flag    <= 1'b0;
                err     <= 1'b0;
            end
        end
    end

endmodule
