
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    
    reg [6:0] state;

    
    reg disc_out;
    reg flag_out;
    reg err_out;

    
    assign disc = disc_out;
    assign flag = flag_out;
    assign err  = err_out;

    always @(posedge clk) begin
        if (reset) begin
            state   <= 7'b0;
            disc_out <= 1'b0;
            flag_out <= 1'b0;
            err_out  <= 1'b0;
        end else begin
            
            state <= {state[5:0], in};

            
            disc_out = (state == 7'b1111110);
            flag_out = (state == 7'b11111110);
            err_out  = (state == 7'b11111111);
        end
    end

endmodule
