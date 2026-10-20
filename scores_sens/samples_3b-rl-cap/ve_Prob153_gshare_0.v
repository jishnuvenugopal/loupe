
module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    
    reg [6:0] branch_history;

    
    reg [6:0] global_pc;

    
    reg [7:0] pht [0:127];

    
    reg [1:0] counter;

    
    wire predicted_taken;

    
    reg [6:0] history_next;

    
    reg [1:0] pht_entry_next;

    
    wire [6:0] hash;
    assign hash = global_pc ^ branch_history;

    
    wire [6:0] pht_index;
    assign pht_index = hash[6:0];

    
    reg [7:0] pht_entry;

    
    always @(*) begin
        if (pht_index < 128)
            pht_entry = pht[pht_index];
        else
            pht_entry = 2'b00;
    end

    
    assign counter = pht_entry[1:0];

    
    assign predicted_taken = (counter > 1'b0);

    
    always @(*) begin
        if (predicted_taken)
            history_next = branch_history << 1;
        else
            history_next = branch_history << 1;
    end

    
    always @(*) begin
        if (predicted_taken)
            pht_entry_next = counter + 2'b01;
        else
            pht_entry_next = 2'b00;
    end

    
    always @(*) begin
        if (pht_index < 128)
            pht[pht_index] = pht_entry_next;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'b0;
            global_pc <= 7'b0;
        end else if (predict_valid) begin
            branch_history <= branch_history << 1;
            if (predicted_taken)
                branch_history[6] <= 1'b1;
            else
                branch_history[6] <= 1'b0;
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'b0;
            global_pc <= 7'b0;
        end else if (train_valid) begin
            if (train_mispredicted) begin
                branch_history <= train_history;
            end else begin
                branch_history <= branch_history << 1;
                if (train_taken)
                    branch_history[6] <= 1'b1;
                else
                    branch_history[6] <= 1'b0;
            end
        end
    end

    
    assign predict_taken = predicted_taken;
    assign predict_history = branch_history;

endmodule
