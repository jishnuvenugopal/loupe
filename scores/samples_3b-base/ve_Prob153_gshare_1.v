
module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  predict_pc [6:0],
    output reg predict_taken,
    output reg [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  train_history [6:0],
    input  train_pc [6:0]
);

    
    localparam PHT_SIZE = 128;
    localparam HISTORY_SIZE = 7;

    
    reg [HISTORY_SIZE-1:0] global_history;

    
    reg [1:0] pht[PHT_SIZE-1:0];

    
    function [6:0] calculate_index(input [6:0] pc, input [HISTORY_SIZE-1:0] history);
        calculate_index = pc ^ history;
    endfunction

    
    function [1:0] saturate_counter(input [1:0] counter);
        if (counter == 2'b11) begin
            saturate_counter = 2'b11;
        end else if (counter == 2'b10) begin
            saturate_counter = 2'b11;
        end else if (counter == 2'b01) begin
            saturate_counter = 2'b10;
        end else begin
            saturate_counter = counter + 1;
        end
    endfunction

    
    function update_pht(input [6:0] index, input [1:0] counter, input train_mispredicted);
        if (train_mispredicted) begin
            pht[index] = 2'b00;
 
        end else begin
            pht[index] = saturate_counter(pht[index]);
        end
    endfunction

    
    function [1:0] predict_branch(input [6:0] index);
        predict_branch = pht[index];
    endfunction

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0;
 i < PHT_SIZE;
 i++) begin
                pht[i] <= 2'b00;
            end
        end else begin
            if (predict_valid) begin
                
                reg [6:0] index = calculate_index(predict_pc, global_history);

                
                reg [1:0] prediction = predict_branch(index);

                
                global_history = {global_history[6:0], prediction};

                
                predict_taken <= prediction[1];
                predict_history <= global_history;
            end

            if (train_valid) begin
                
                reg [6:0] index = calculate_index(train_pc, global_history);

                
                update_pht(index, pht[index], train_mispredicted);

                
                if (index == calculate_index(predict_pc, global_history)) begin
                    global_history = {global_history[6:0], train_taken};
                end
            end
        end
    end

endmodule
