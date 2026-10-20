
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    
    reg [6:0] state;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            
            state <= {state[5:0], in};

            
            if (state[0:5] == 6'b111111) begin
                disc <= 1'b1;
                flag <= 1'b0;
                err  <= 1'b0;
            end
            
            else if (state[0:6] == 7'b1111111) begin
                disc <= 1'b0;
                flag <= 1'b0;
                err  <= 1'b1;
            end
            
            else begin
                disc <= 1'b0;
                flag <= 1'b0;
                err  <= 1'b0;
            end
        end
    end

endmodule
