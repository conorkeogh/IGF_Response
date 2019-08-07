# Copy/paste from produce_plots_KW.R
# Adapted for only RTT groups (controls excluded)

# Set up plots

# Part 1: Set up all plotting functions
# Part 2: Load data & produce plots
# Part 3: Arrange individual plots into larger plots

# Import libraries
library(ggplot2)
library(reshape2)
library(gplots)

####################################################################################
####################################################################################
##################################### PART 1 #######################################
############################# DEFINE PLOTTING FUNCTIONS ############################
####################################################################################
####################################################################################

############################################################
######################### POWER ############################
############################################################

# Set row / column names:
powercolumns = c('Fp2', 'C4', 'O2', 'T4', 'Fp1', 'C3', 'T3', 'O1', 'R hemi', 'L hemi', 'Overall')
powerrows = c('Theta', 'Alpha', 'Beta', 'Delta', 'Gamma', 'Overall')

# Define plotting function for RTT / control power plots:
ck_power_matrix <- function(power_data) {
  
  colnames(power_data) <- powercolumns
  rownames(power_data) <- powerrows
  
  melt_power_data = melt(as.matrix(power_data))
  
  power_data_plot <- ggplot(data = melt_power_data, aes(x=Var2, y=Var1, fill=value)) + 
    geom_tile(color = "white")  
  
  power_data_plot <- power_data_plot + theme_minimal() 
  
  power_data_plot <- power_data_plot + 
    scale_fill_gradient2(low="white", high="red", 
                         midpoint=15, limit=c(0,36), space = "Lab", 
                         name = "Power\n(dB)", 
                         guide = "colorbar", 
                         breaks = c(1,35), 
                         labels = c("Low", "High")
    )
  
  power_data_plot <- power_data_plot + 
    scale_x_discrete(name="Location", position = "top") + 
    scale_y_discrete(name="Band",
                     limits = rev(levels(melt_power_data$Var1)))
  
  power_data_plot <- power_data_plot + 
    theme(legend.title = element_text(size = 10, face = "bold"), 
          legend.text = element_text(size=8, face = "bold"), 
          legend.background=element_rect(fill = "gray90", size = 0.5),
          legend.key.height = unit(0.07, "npc"),
          legend.key.width = unit(0.08, "npc")
    )
  
  power_data_plot <- power_data_plot + 
    theme(axis.text.x = element_text(angle=45, vjust=0, size=20, hjust=0, face="bold"), 
          axis.title.x = element_text(size = 24, face="bold"), 
          axis.title.y = element_text(size = 24, face="bold"), 
          axis.text.y = element_text(size = 20, face = "bold")
    )
  
  power_data_plot <- power_data_plot + theme(panel.border = element_rect(fill=NA, size=1))
  
  power_data_plot <-	power_data_plot + coord_fixed()
  
  return(power_data_plot)
  
}

############################################################
######################### ASYMMETRY ########################
############################################################

# Set row / column names:
asymmetry_columns = c('Frontal', 'Parietal', 'Temporal', 'Occipital', 'Overall')
asymmetry_rows = c('Theta', 'Alpha', 'Beta', 'Delta', 'Gamma', 'Overall')

# Define plotting function:
ck_asymmetry_matrix <- function(asymmetry_data) {
  
  colnames(asymmetry_data) <- asymmetry_columns
  rownames(asymmetry_data) <- asymmetry_rows
  
  melt_asymmetry_data = melt(as.matrix(asymmetry_data))
  
  asymmetry_data_plot <- ggplot(data = melt_asymmetry_data, 
                                aes(x=Var2, y=Var1, fill=value)) + 
    geom_tile(color = "white")  
  
  asymmetry_data_plot <- asymmetry_data_plot + theme_minimal() 
  
  asymmetry_data_plot <- asymmetry_data_plot + 
    scale_fill_gradient2(low="blue", high="red", mid="white", 
                         midpoint=0, limit=c(-250,250), space = "Lab", 
                         name = "", 
                         guide = "colorbar", 
                         breaks = c(-200,200), 
                         labels = c("R > L", "L > R")
    )
  
  asymmetry_data_plot <- asymmetry_data_plot + 
    scale_x_discrete(name="Location", position = "top") + 
    scale_y_discrete(name="Band",
                     limits=rev(levels(melt_asymmetry_data$Var1)))
  
  asymmetry_data_plot <- asymmetry_data_plot + 
    theme(legend.title = element_text(size = 10, face = "bold"), 
          legend.text = element_text(size=8, face = "bold"), 
          legend.background=element_rect(fill = "gray90", size = 0.5),
          legend.key.height = unit(0.12, "npc"),
          legend.key.width = unit(0.1, "npc")
    )
  
  asymmetry_data_plot <- asymmetry_data_plot + 
    theme(axis.text.x = element_text(angle=45, vjust=0, size=20, hjust=0, face="bold"), 
          axis.title.x = element_text(size = 24, face="bold"), 
          axis.title.y = element_text(size = 24, face="bold"), 
          axis.text.y = element_text(size = 20, face = "bold")
    )
  
  asymmetry_data_plot <- asymmetry_data_plot + theme(panel.border = element_rect(fill=NA, size=1))
  
  asymmetry_data_plot <-	asymmetry_data_plot + coord_fixed()
  
  return(asymmetry_data_plot)
}

############################################################
######################### COHERENCE ########################
############################################################

# Set labels:
coherence_columns = c('Fp2', 'C4', 'O2', 'T4', 'Fp1', 'C3', 'T3', 'O1')

# Define function to produce plots:
ck_coherence_matrix <- function(coherence_data) {
  
  colnames(coherence_data) <- coherence_columns
  rownames(coherence_data) <- coherence_columns
  
  melt_coherence_data = melt(as.matrix(coherence_data))
  
  coherence_data_plot <- ggplot(data = melt_coherence_data, 
                                aes(x=Var1, y=Var2, fill=value)
  ) + 
    geom_tile(color = "white")  
  
  coherence_data_plot <- coherence_data_plot + theme_minimal() 
  
  coherence_data_plot <- coherence_data_plot + scale_fill_gradient2(low="white", high="red", 
                                                                    midpoint=0.4, limit=c(0.2,0.6), space = "Lab", 
                                                                    name = "Coherence", 
                                                                    guide = "colorbar", 
                                                                    breaks = c(0.2, 0.4, 0.6)
  )
  
  coherence_data_plot <- coherence_data_plot + 
    scale_x_discrete(name="", position = "top") + 
    scale_y_discrete(name="",
                     limits = rev(levels(melt_coherence_data$Var2))
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(legend.title = element_text(size = 10, face = "bold"), 
          legend.text = element_text(size=8, face = "bold"), 
          legend.background=element_rect(fill = "gray90", size = 0.5))
  
  coherence_data_plot <- coherence_data_plot + 
    theme(axis.text.x = element_text(angle=45, vjust=0, size=12, hjust=0, face="bold"), 
          axis.title.x = element_text(size = 16, face="bold"), 
          axis.title.y = element_text(size = 16, face="bold"), 
          axis.text.y = element_text(size = 12, face = "bold")
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(panel.border = element_rect(fill=NA, size=1))
  
  coherence_data_plot <-	coherence_data_plot + coord_fixed()
  
  return(coherence_data_plot)
}

############################################################
#########################  Network  ########################
############################################################

# Set labels:
coherence_columns_short = c('Fp2', 'C4', 'O2', 'T4', 'Fp1', 'C3', 'T3', 'O1')

network_columns_short = c('Fp2-C4', 'Fp2-O2', 'Fp2-T4', 'Fp2-Fp1', 'Fp2-C3', 'Fp2-T3', 'Fp2-O1',
                          'C4-O2', 'C4-T4', 'C4-Fp1', 'C4-C3', 'C4-T3', 'C4-O1', 'O2-T4',
                          'O2-Fp1', 'O2-C3', 'O2-T3', 'O2-O1', 'T4-Fp1', 'T4-C3', 'T4-T3',
                          'T4-O1', 'Fp1-C3', 'Fp1-T3', 'Fp1-O1', 'C3-T3', 'C3-O1', 'T3-O1'
)

network_columns = c(paste0(network_columns_short, " Theta"),
                    paste0(network_columns_short, " Alpha"),
                    paste0(network_columns_short, " Beta"),
                    paste0(network_columns_short, " Delta"),
                    paste0(network_columns_short, " Gamma"),
                    paste0(network_columns_short, " Overall")
)

network_columns_groups = network_columns
network_columns_groups[1] = 'Theta'
network_columns_groups[2:28] = ' '
network_columns_groups[29] = 'Alpha'
network_columns_groups[30:56] = ' '
network_columns_groups[57] = 'Beta'
network_columns_groups[58:84] = ' '
network_columns_groups[85] = 'Delta'
network_columns_groups[86:112] = ' '
network_columns_groups[113] = 'Gamma'
network_columns_groups[114:140] = ' '
network_columns_groups[141] = 'Overall'
network_columns_groups[142:168] = ' '

colpalette <- colorRampPalette(c("blue", 'white', 'red'))(300)


############################################################
#########################  Function  #######################
############################################################

# Define function to produce plots:
ck_cov_matrix <- function(coherence_data) {
  
  #colnames(coherence_data) <- network_columns_groups
  #rownames(coherence_data) <- network_columns_groups
  
  # Set diagonal to 1:
  for (i in 1:168){
    coherence_data[i,i] = 1
  }
  
  melt_coherence_data = melt(as.matrix(coherence_data))
  
  coherence_data_plot <- ggplot(data = melt_coherence_data, 
                                aes(x=Var1, y=Var2, fill=value)
  ) + 
    geom_tile(color = "white")  
  
  coherence_data_plot <- coherence_data_plot + theme_minimal() 
  
  coherence_data_plot <- coherence_data_plot + scale_fill_gradient2(low="blue", high="red",
                                                                    limit=c(-0.06,0.12), 
                                                                    name = "Covariance", 
                                                                    guide = "colorbar", 
                                                                    breaks = c(-0.05, 0.12),
                                                                    labels = c("Low", "High")
  )
  
  coherence_data_plot <- coherence_data_plot + 
    scale_x_continuous(name="",
                     position = "top",
                     breaks = c(1,29,57,85,113,141),
                     labels = c('Theta','Alpha','Beta','Delta','Gamma','Overall'),
                     expand=c(0,0)) + 
    scale_y_discrete(name="",
                     limits = rev(levels(melt_coherence_data$Var2)),
                     labels = rev(network_columns_groups),
                     expand=c(0,0)
    )
  
   coherence_data_plot <- coherence_data_plot + 
     theme(legend.title = element_text(size = 10, face = "bold"), 
           legend.text = element_text(size=8, face = "bold"), 
           legend.background=element_rect(fill = "gray90", size = 0.5),
           legend.key.height = unit(0.15, "npc"),
          legend.key.width = unit(0.08, "npc")
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(axis.text.x = element_text(angle=45, size=12, vjust = 0, hjust = 0, face="bold"), 
          axis.title.x = element_text(size = 16, face="bold"), 
          axis.title.y = element_text(size = 16, face="bold"), 
          axis.text.y = element_text(size = 12, face = "bold")
    )
  
   coherence_data_plot <- coherence_data_plot + 
    theme(panel.border = element_rect(fill=NA, size=1))
  
  coherence_data_plot <-	coherence_data_plot + coord_fixed()
  
  coherence_data_plot <-	coherence_data_plot + coord_cartesian(xlim=c(1,168), ylim=c(1,168))
  
  return(coherence_data_plot)
}


####################################################################################
####################################################################################
##################################### PART 2 #######################################
############################ PRODUCE INDIVIDUAL PLOTS ##############################
####################################################################################
####################################################################################

# Below for covariance plots only - use above functions as required for any plots

treated_t1_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t1_cov.csv', header = FALSE)
treated_t1_cov_plot <- ck_cov_matrix(treated_t1_cov)
ggsave("treated_t1_cov_m.pdf", plot=treated_t1_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

untreated_t1_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/untreated_t1_cov.csv', header = FALSE)
untreated_t1_cov_plot <- ck_cov_matrix(untreated_t1_cov)
ggsave("untreated_t1_cov_m.pdf", plot=untreated_t1_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

treated_t2_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t2_cov.csv', header = FALSE)
treated_t2_cov_plot <- ck_cov_matrix(treated_t2_cov)
ggsave("treated_t2_cov_m.pdf", plot=treated_t2_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

untreated_t2_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/untreated_t2_cov.csv', header = FALSE)
untreated_t2_cov_plot <- ck_cov_matrix(untreated_t2_cov)
ggsave("untreated_t2_cov_m.pdf", plot=untreated_t2_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

resp_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/resp_cov.csv', header = FALSE)
resp_cov_plot <- ck_cov_matrix(resp_cov)
ggsave("resp_t1_cov_m.pdf", plot=resp_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

none_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/none_cov.csv', header = FALSE)
none_cov_plot <- ck_cov_matrix(none_cov)
ggsave("none_t1_cov_m.pdf", plot=none_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

resp_t2_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/resp_t2_cov.csv', header = FALSE)
resp_t2_cov_plot <- ck_cov_matrix(resp_t2_cov)
ggsave("resp_t2_cov_m.pdf", plot=resp_t2_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

none_t2_cov = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/none_t2_cov.csv', header = FALSE)
none_t2_cov_plot <- ck_cov_matrix(none_t2_cov)
ggsave("none_t2_cov_m.pdf", plot=none_t2_cov_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')




####################################################################################
####################################################################################
##################################### PART 3 #######################################
############################ OVERALL POPOUT PLOTS ##############################
####################################################################################
####################################################################################

# Define function to produce plots:
ck_cov_overall_matrix <- function(coherence_data) {
  
  # Set diagonal to 1:
  for (i in 1:28){
  coherence_data[i,i] = 1
  }
  
  
  colnames(coherence_data) <- network_columns_short
  rownames(coherence_data) <- network_columns_short
  
  melt_coherence_data = melt(as.matrix(coherence_data))
  
  coherence_data_plot <- ggplot(data = melt_coherence_data, 
                                aes(x=Var1, y=Var2, fill=value)
  ) + 
    geom_tile(color = "white")  
  
  coherence_data_plot <- coherence_data_plot + theme_minimal() 
  
  coherence_data_plot <- coherence_data_plot + scale_fill_gradient2(low="blue", high="red",
                                                                    limit=c(-0.06,0.12), 
                                                                    name = "Covariance", 
                                                                    guide = "colorbar", 
                                                                    breaks = c(-0.06, 0.12),
                                                                    labels = c("Low", "High")
  )
  
  coherence_data_plot <- coherence_data_plot + 
    scale_x_discrete(name="",
                       position = "top"
                       ) + 
    scale_y_discrete(name="",
                     limits = rev(levels(melt_coherence_data$Var2))
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(legend.title = element_text(size = 10, face = "bold"), 
          legend.text = element_text(size=8, face = "bold"), 
          legend.background=element_rect(fill = "gray90", size = 0.5),
          legend.key.height = unit(0.14, "npc"),
          legend.key.width = unit(0.08, "npc")
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(axis.text.x = element_text(angle=90, size=10, vjust = 0, hjust = 0, face="bold"), 
          axis.title.x = element_text(size = 16, face="bold"), 
          axis.title.y = element_text(size = 16, face="bold"), 
          axis.text.y = element_text(size = 10, face = "bold")
    )
  
  coherence_data_plot <- coherence_data_plot + 
    theme(panel.border = element_rect(fill=NA, size=1))
  
  coherence_data_plot <-	coherence_data_plot + coord_fixed()
  
  return(coherence_data_plot)
}

treated_t1_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t1_overall_cov.csv', header = FALSE)
treated_t1_cov_overall_plot <- ck_cov_overall_matrix(treated_t1_cov_overall)
ggsave("treated_t1_cov_overall_m.pdf", plot=treated_t1_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

untreated_t1_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/untreated_t1_overall_cov.csv', header = FALSE)
untreated_t1_cov_overall_plot <- ck_cov_overall_matrix(untreated_t1_cov_overall)
ggsave("untreated_t1_cov_overall_m.pdf", plot=untreated_t1_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

treated_t2_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/treated_t2_overall_cov.csv', header = FALSE)
treated_t2_cov_overall_plot <- ck_cov_overall_matrix(treated_t2_cov_overall)
ggsave("treated_t2_cov_overall_m.pdf", plot=treated_t2_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

untreated_t2_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/untreated_t2_overall_cov.csv', header = FALSE)
untreated_t2_cov_overall_plot <- ck_cov_overall_matrix(untreated_t2_cov_overall)
ggsave("untreated_t2_cov_overall_m.pdf", plot=untreated_t2_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

resp_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/resp_overall_cov.csv', header = FALSE)
resp_cov_overall_plot <- ck_cov_overall_matrix(resp_cov_overall)
ggsave("resp_t1_cov_overall_m.pdf", plot=resp_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

none_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/none_overall_cov.csv', header = FALSE)
none_cov_plot_overall <- ck_cov_overall_matrix(none_cov_overall)
ggsave("none_t1_cov_overall_m.pdf", plot=none_cov_plot_overall, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

resp_t2_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/resp_t2_overall_cov.csv', header = FALSE)
resp_t2_cov_overall_plot <- ck_cov_overall_matrix(resp_t2_cov_overall)
ggsave("resp_t2_cov_overall_m.pdf", plot=resp_t2_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')

none_t2_cov_overall = read.csv('/Volumes/File Storage/EEG Project/Data/Results/Extra Figures/Covariance/none_t2_overall_cov.csv', header = FALSE)
none_t2_cov_overall_plot <- ck_cov_overall_matrix(none_t2_cov_overall)
ggsave("none_t2_cov_overall_m.pdf", plot=none_t2_cov_overall_plot, path='/Volumes/File Storage/EEG Project/Data/Results/Extra Figures IGF/Plots/Covariance/')


