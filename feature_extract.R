library(plyr)

feature_extract <- function(features) {
  domains <- list(t="Time", f="Frequency")
  sources <- list(Body="Body", Gravity="Gravity")
  sensors <- list(Acc="Acceleration", Gyro="Gyroscopic")
  jerks <- list(Jerk="Yes", Default="No")
  magnitudes <- list(Mag="Yes", Default="No")
  statistics <- list(mean="Mean", std="Standard Deviation")
  axes <- list(X="X", Y="Y", Z="Z")
  
  regex.pattern <- paste0("^(", paste(names(domains), collapse="|"), ")")
  regex.pattern <- paste0(regex.pattern, "(", paste(names(sources), collapse="|"), ")+")
  regex.pattern <- paste0(regex.pattern, "(", paste(names(sensors), collapse="|"), ")")
  regex.pattern <- paste0(regex.pattern, "(", paste(names(jerks), collapse="|"), ")?")
  regex.pattern <- paste0(regex.pattern, "(", paste(names(magnitudes), collapse="|"), ")?")
  regex.pattern <- paste0(regex.pattern, "-(", paste(names(statistics), collapse="|"), ")\\(\\)")
  regex.pattern <- paste0(regex.pattern, "-?(", paste(names(axes), collapse="|"), ")?")
  
  matches <- regexec(regex.pattern, features)
  features.by.parts <- regmatches(features, matches)
  
  feature.parts <- c(domains, sources, sensors, jerks, 
                     magnitudes, statistics, axes)
  
  features.final <- ldply(features.by.parts, function(x) {
      x <- x[-1]
      y <- sapply(x, function(y) {
          if (y %in% names(feature.parts))
            feature.parts[[y]]
          else if ("Default" %in% names(feature.parts))
            feature.parts[["Default"]]
          else
            NA
        }
      )
    }
  )
  
  colnames(features.final) <- c("domain", "source", "sensor", "jerk", 
                                "magnitude", "statistic", "axis")
  features.final
}