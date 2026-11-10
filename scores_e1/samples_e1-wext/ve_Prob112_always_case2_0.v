
module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    
    function [1:0] find_position(input [3:0] in);
        if (in == 0) begin
            find_position = 2'b00;
        end else begin
            find_position = 2'b01;
            for (int i = 0;
 i < 4;
 i++) begin
                if (in[i] == 1) begin
                    find_position = 2'b00 + i;
                    break;
                end
            end
        end
    endfunction

    
    assign pos = find_position(in);

endmodule
