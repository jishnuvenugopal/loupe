
module TopModule (
    input  clk,
    input  d,
    output q
);

    
    reg [1:0] edge_counter;

    
    reg q_reg;

    
    always @(posedge clk) begin
        edge_counter <= edge_counter + 1'b1;
    end

    
    always @(negedge clk) begin
        edge_counter <= edge_counter - 1'b1;
    end

    
    always @(posedge clk or negedge clk) begin
        if (edge_counter == 2'b10) begin
            
            q_reg <= d;
        end else if (edge_counter == 2'b01) begin
            
            q_reg <= ~q_reg;
        end
    end

    
    assign q = q_reg;

endmodule
