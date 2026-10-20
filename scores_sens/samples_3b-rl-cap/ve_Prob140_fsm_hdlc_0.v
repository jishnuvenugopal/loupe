
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    
    reg [5:0] data;

    
    reg disc_reg, flag_reg, err_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            data   <= 6'b0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg  <= 1'b0;
        end else begin
            
            data <= {data[4:0], in};

            
            if (data == 6'b011111) begin
                flag_reg <= 1'b1;
            end else begin
                flag_reg <= 1'b0;
            end

            
            if (data == 6'b0111111) begin
                err_reg <= 1'b1;
            end else begin
                err_reg <= 1'b0;
            end

            
            if (data[5:1] == 5'b11111) begin
                disc_reg <= 1'b1;
            end else begin
                disc_reg <= 1'b0;
            end

            
            disc <= disc_reg;
            flag <= flag_reg;
            err  <= err_reg;
        end
    end

endmodule
