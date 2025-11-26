# Installer les packages avant d'exécuter le script
library(shiny)
library(ggplot2)
library(shinythemes)
library(bslib)

# Charger les coefficients
coef <- readRDS("coefs_models.RDS")
coef_freq <-coef$frequence
coef_sev <- coef$severity

# charger home
home <- readRDS("home.rds")


fmt_montant <- function(x) {
    format(round(x, 2), big.mark = " ", decimal.mark = ",")
}

# -------------------------------------------
# Interface utilisateur

ui <- fluidPage(
    theme = bslib::bs_theme(
        bootswatch = "flatly",
        primary = "#002b5c",
        secondary = "#8b9cb6",
        info = "#1f78b4",
        success = "#33a02c",
        danger = "#e31a1c",
        base_font = bslib::font_google("Lexend"),
        heading_font = bslib::font_google("Montserrat"),
        bg = "#F4F6F8",
        fg = "#1C1C1C",
        font_scale = 1.1
    ),
    titlePanel("Outil de calcul de prime en assurance habitation"),

    sidebarLayout(
        sidebarPanel(
            h3("Caractéristiques du risque"),

            h4("Profil de l'assuré"),
            selectInput(
                "group_age_oldest_insured",
                "Âge de l'assuré le plus âgé",
                choices = levels(home$group_age_oldest_insured)
            ),


            selectInput(
                "marital_status", "Statut matrimonial",
                choices = c(
                    "Célibataire" = "Single",
                    "Marié(e)"    = "Married",
                    "Divorcé(e)"  = "Divorced",
                    "Veuf/Veuve"  = "Widowed"
                  )
            ),

            selectInput(
                "insured_employment", "Statut d'emploi",
                choices = c(
                    "Assurance"          = "Insurance",
                    "Services publics"   = "Public Service",
                    "Retraité"           = "Retired",
                    "Étudiant"           = "Student",
                    "Chômeur"            = "Unemployed",
                    "Autre"              = "Other"
                )
            ),

            selectInput(
                "smoker", "Fumeur",
                choices = c("Non" = "No", "Oui" = "Yes")
            ),

            h4("Caractéristiques de la maison"),
            selectInput(
                "house_type", "Type de maison",
                choices = c(
                    "Immeuble commercial"                 = "Commercial building",
                    "Maison unifamiliale détachée"        = "Detached",
                    "Duplex (2 logements)"                = "Duplex",
                    "Ferme / maison de ferme"             = "Farm",
                    "Maison en rangée (townhouse)"        = "Row house",
                    "Maison jumelée (semi-détachée)"      = "Semi-detached",
                    "Triplex (3 logements)"               = "Triplex"
                )
            ),

            selectInput(
                "exterior_cladding", "Revêtement extérieur",
                choices = c(
                    "Brique – très résistant au feu"           = "Brick",
                    "Vinyle – sensible à la chaleur et au feu" = "Vinyl",
                    "Bois – inflammable, risque accru"         = "Wood"
                )
            ),

            selectInput(
                "etat_toit", "État du toit",
                choices = c(
                    "Toit neuf – très bonne condition"     = "Neuf",
                    "Bon état – usure normale"             = "Bon",
                    "Toit ancien – risque d’infiltration"  = "Ancien"
                )
            ),

            selectInput(
                "region", "Région",
                choices = levels(factor(home$region))
            ),

            selectInput(
                "water_body_proximity", "Proximité plan d'eau",
                choices = c(
                    "Non – pas près d’un plan d’eau" = "No",
                    "Oui – près d’un plan d’eau"     = "Yes"
                )
            ),

            selectInput(
                "skylight_presence", "Puits de lumière",
                choices = c(
                    "Aucun puits de lumière"         = "No",
                    "Présence d’un puits de lumière" = "Yes"
                )
            ),

            selectInput(
                "pool_presence", "Présence d'une piscine",
                choices = c(
                    "Non"   = "No",
                    "Oui"   = "Yes"
                )
            ),

            h4("Prévention"),
            selectInput(
                "alarm_system", "Système d'alarme",
                choices = c(
                    "Aucun système d’alarme"                  = "No alarm system",
                    "Alarme incendie seulement"               = "Fire only",
                    "Alarme intrusion seulement"              = "Theft only",
                    "Alarme incendie + intrusion (complet)"   = "Fire and Theft"
                )
            ),

            selectInput(
                "hydrant_proximity", "Proximité borne-fontaine",
                choices = c(
                    "Non – éloigné d’une borne-fontaine" = "No",
                    "Oui – proche d’une borne-fontaine"  = "Yes"
                )
            ),

            selectInput(
                "fire_station_proximity", "Proximité caserne",
                choices = c(
                    "Non – éloigné d’une caserne" = "No",
                    "Oui – proche d’une caserne"  = "Yes"
                )
            ),

            selectInput(
                "heating_type", "Type de chauffage",
                choices = c(
                    "Électricité – faible risque d’incendie"             = "Electricity",
                    "Gaz / Mazout – risque modéré (fuite ou combustion)" = "Gas/Oil",
                    "Autre type de chauffage"                             = "Other",
                    "Bois – combustible, risque accru d’incendie"         = "Wood"
                )
            ),

            selectInput(
                "auxiliary_heating", "Chauffage d'appoint",
                choices = c(
                    "Non – aucun chauffage d’appoint"           = "No",
                    "Oui – présence d’un chauffage d’appoint"   = "Yes"
                )
            ),

            selectInput(
                "residence_stability_group", "Stabilité de résidence",
                choices = c(
                    "Très instable (<= 2 ans au même endroit)" = "Très instable",
                    "Modérément stable (entre 3 et 10 ans)"    = "Modérément stable",
                    "Stable (entre 11 et 25 ans)"              = "Stable",
                    "Très stable (plus de 25 ans)"             = "Très stable"
                )
            ),

            h4("Contrat"),
            selectInput(
                "deductible", "Franchise",
                choices = c(
                    "250 $"   = "250",
                    "500 $"   = "500",
                    "1 000 $" = "1000",
                    "2 000 $" = "2000"
                )
            ),

            selectInput(
                "multi_product_discount", "Rabais multi-produits",
                choices = c(
                    "Non – aucun autre produit chez l’assureur" = "No",
                    "Oui – client multi-produits (rabais)"      = "Yes"
                )
            ),

            selectInput(
                "fidelity_cat", "Fidélité",
                choices = c(
                    "≤ 2 ans – nouveau client"     = "<=2",
                    "2 à 6 ans – fidélité moyenne" = "2-6",
                    "6 à 10 ans – client fidèle"   = "6-10",
                    "> 10 ans – très fidèle"       = ">10"
                )
            ),

            selectInput(
                "credit_score_level", "Score de crédit",
                choices = c(
                    "0 – 692  (1%–20%)  – très faible"   = "1%-20%",
                    "692 – 742  (21%–40%)  – faible"     = "21%-40%",
                    "742 – 789  (41%–60%)  – moyenne"    = "41%-60%",
                    "789 – 832  (61%–80%)  – bonne"      = "61%-80%",
                    "> 832  (81%–100%)  – excellente"    = "81%-100%"
                )
            ),

            selectInput(
                "past_claims", "Historique de sinistres",
                choices = levels(factor(home$past_claims))
            ),

            selectInput(
                "room_rental", "Location de chambre",
                choices = c(
                    "Non – aucune chambre louée" = "No",
                    "Oui – chambre(s) louée(s)"  = "Yes"
                )
            ),

            selectInput(
                "commercial_activities", "Activités commerciales",
                choices = c(
                    "Non – aucune activité commerciale"   = "No",
                    "Oui – activité commerciale présente" = "Yes"
                )
            ),

            selectInput(
                "earthquake_coverage", "Couverture pour tremblements de terre",
                choices = c(
                    "Non"   = "No",
                    "Oui"   = "Yes"
                )
            ),

            selectInput(
                "liability_limit", "Montant de la limite",
                choices = c(
                    "1 million $"   = "1M",
                    "2 millions $"   = "2M"
                )
            ),


            br(),
            actionButton("go_calc", "Calculer la prime", class = "btn-primary btn-lg")
        ),


        mainPanel(
            h3("Résultats"),
            br(),

            fluidRow(
                column(
                    6,
                    wellPanel(
                        h4("Fréquence attendue"),
                        textOutput("freq_text"),
                        tags$small("Nombre de sinistres attendus dans l'année.")
                    )
                ),
                column(
                    6,
                    wellPanel(
                        h4("Sévérité attendue"),
                        textOutput("sev_text"),
                        tags$small("Coût moyen par sinistre.")
                    )
                )
            ),

            fluidRow(
                column(
                    6,
                    wellPanel(
                        h4("Prime pure"),
                        textOutput("pure_premium_text"),
                        tags$small("Prime théorique = fréquence × sévérité.")
                    )
                ),
                column(
                    6,
                    wellPanel(
                        h4("Prime commerciale"),
                        textOutput("premium_text"),
                        tags$small("Prime avec chargements frais + profit.")
                    )
                )
            ),

            hr(),
            h4("Détail des entrées"),
            tableOutput("inputs_table"),

            hr(),
            h3("Position de votre prime dans le portefeuille"),

            plotOutput("pure_premium_plot"),
            br(),
            textOutput("percentile_text")

        )
    )
)



# -------------------------------------------
# Serveur

server <- function(input, output, session) {

    # Observation définie par l'utilisateur
    risk_inputs <- eventReactive(input$go_calc, {
        data.frame(
            exterior_cladding        = factor(input$exterior_cladding,
                                              levels = levels(factor(home$exterior_cladding))),
            residence_stability_group = factor(input$residence_stability_group,
                                               levels = levels(factor(home$residence_stability_group))),
            deductible               = factor(input$deductible,
                                              levels = levels(factor(home$deductible))),
            region                   = factor(input$region,
                                              levels = levels(factor(home$region))),
            alarm_system             = factor(input$alarm_system,
                                              levels = levels(factor(home$alarm_system))),
            hydrant_proximity        = factor(input$hydrant_proximity,
                                              levels = levels(factor(home$hydrant_proximity))),
            fire_station_proximity   = factor(input$fire_station_proximity,
                                              levels = levels(factor(home$fire_station_proximity))),
            heating_type             = factor(input$heating_type,
                                              levels = levels(factor(home$heating_type))),
            fidelity_cat             = factor(input$fidelity_cat,
                                              levels = levels(factor(home$fidelity_cat))),
            insured_employment       = factor(input$insured_employment,
                                              levels = levels(factor(home$insured_employment))),
            multi_product_discount   = factor(input$multi_product_discount,
                                              levels = levels(factor(home$multi_product_discount))),
            smoker                   = factor(input$smoker,
                                              levels = levels(factor(home$smoker))),
            auxiliary_heating        = factor(input$auxiliary_heating,
                                              levels = levels(factor(home$auxiliary_heating))),
            etat_toit                = factor(input$etat_toit,
                                              levels = levels(factor(home$etat_toit))),
            credit_score_level       = factor(input$credit_score_level,
                                              levels = levels(factor(home$credit_score_level))),
            past_claims              = factor(input$past_claims,
                                              levels = levels(factor(home$past_claims))),
            group_age_oldest_insured = factor(input$group_age_oldest_insured,
                                              levels = levels(factor(home$group_age_oldest_insured))),
            marital_status           = factor(input$marital_status,
                                              levels = levels(factor(home$marital_status))),
            house_type               = factor(input$house_type,
                                              levels = levels(factor(home$house_type))),
            water_body_proximity     = factor(input$water_body_proximity,
                                              levels = levels(factor(home$water_body_proximity))),
            skylight_presence        = factor(input$skylight_presence,
                                              levels = levels(factor(home$skylight_presence))),
            room_rental              = factor(input$room_rental,
                                              levels = levels(factor(home$room_rental))),
            commercial_activities    = factor(input$commercial_activities,
                                              levels = levels(factor(home$commercial_activities))),
            earthquake_coverage      = factor(input$earthquake_coverage,
                                              levels = levels(factor(home$earthquake_coverage))),
            liability_limit          = factor(input$liability_limit,
                                              levels = levels(factor(home$liability_limit))),
            pool_presence            = factor(input$pool_presence,
                                              levels = levels(factor(home$pool_presence))),

            earned_exposure = 1,
            stringsAsFactors = FALSE
        )
    })


    # Fonction : calcule mu = exp(η) à partir de coefs + réponses
    compute_mu_log_link <- function(formula, newdata, coefs, offset = NULL) {
        mm <- model.matrix(formula, data = newdata)      # matrice X
        beta <- coefs[colnames(mm)]                     # on aligne les β avec X
        eta  <- drop(mm %*% beta)                       # prédicteur linéaire
        if (!is.null(offset)) {
            eta <- eta + offset
        }
        exp(eta)                                        # lien log
    }

    # Calcul fréquence, sévérité, prime
    results <- reactive({
        new_risk <- risk_inputs()
        if (is.null(new_risk)) return(NULL)

        # --- FRÉQUENCE ---
        freq_formula <- ~ exterior_cladding + residence_stability_group +
            deductible + region + alarm_system + hydrant_proximity +
            fire_station_proximity + heating_type + fidelity_cat +
            insured_employment + multi_product_discount + smoker +
            auxiliary_heating + etat_toit + credit_score_level + past_claims +
            group_age_oldest_insured + marital_status + house_type +
            water_body_proximity + skylight_presence + room_rental +
            commercial_activities

        # offset = log(exposition)
        offset_freq <- log(new_risk$earned_exposure)

        lambda_hat <- compute_mu_log_link(freq_formula, new_risk, coef_freq,
                                          offset = offset_freq)

        # --- SÉVÉRITÉ ---
        sev_formula <- ~ exterior_cladding + region + water_body_proximity +
            earthquake_coverage + fire_station_proximity + liability_limit +
            etat_toit + auxiliary_heating + deductible + pool_presence +
            alarm_system + house_type + heating_type + group_age_oldest_insured +
            multi_product_discount + hydrant_proximity

        sev_hat <- compute_mu_log_link(sev_formula, new_risk, coef_sev)

        # --- PRIME ---
        pure_premium <- lambda_hat * sev_hat

        frais_fixes <- 0.03
        frais_var <- 0.15
        profit <- 0.05
        premium  <- pure_premium * (1 + frais_fixes) / (1 - frais_var - profit)

        list(
            freq_hat      = lambda_hat,
            sev_hat       = sev_hat,
            pure_premium  = pure_premium,
            premium       = premium,
            month         = premium/12

        )
    })

    # Sorties
    output$freq_text <- renderText({
        res <- results()
        if (is.null(res)) return("")
        paste0(round(res$freq_hat, 4), " sinistres attendus")
    })

    output$sev_text <- renderText({
        res <- results()
        if (is.null(res)) return("")
        paste0(fmt_montant(res$sev_hat), " $ par sinistre")
    })

    output$pure_premium_text <- renderText({
        res <- results()
        if (is.null(res)) return("")
        paste0(fmt_montant(res$pure_premium), " $ (prime pure)")
    })

    output$premium_text <- renderText({
        res <- results()
        if (is.null(res)) return("")
        paste0(fmt_montant(res$premium), " $ annuelle
               et ", fmt_montant(res$month), " $ mensuelle")
    })

    output$inputs_table <- renderTable({
        req(risk_inputs())
        new_risk <- risk_inputs()

        data.frame(
            Variable = names(new_risk),
            Valeur   = t(new_risk),
            row.names = NULL,
            check.names = FALSE
        )
    })


    # graphique
    output$pure_premium_plot <- renderPlot({
        res <- results()
        req(res)

        pure_portefeuille <- home$prime_pure
        pure_client <- as.numeric(res$pure_premium)
        pure_portefeuille <- pure_portefeuille[!is.na(pure_portefeuille)]

        library(ggplot2)
        library(scales)

        ggplot(data.frame(prime_pure = pure_portefeuille),
               aes(x = prime_pure)) +
            geom_histogram(
                aes(y = after_stat(count) / sum(after_stat(count))),
                bins = 30,
                fill = "#2A9D8F",
                color = "white"
            ) +
            geom_vline(
                xintercept = pure_client,
                linetype = "dashed",
                linewidth = 1,
                color = "#E76F51"
            ) +
            scale_y_continuous(labels = percent_format(accuracy = 1)) +
            labs(
                title = "Répartition des primes pures dans le portefeuille",
                x = "Prime pure annuelle ($)",
                y = "% du portefeuille"
            ) +
            theme_minimal(base_size = 14)
    })


    # position du client
    output$percentile_text <- renderText({
        res <- results()
        req(res)

        pure_portefeuille <- home$prime_pure
        pure_client <- as.numeric(res$pure_premium)
        pure_portefeuille <- pure_portefeuille[!is.na(pure_portefeuille)]

        # % des contrats qui ont une prime pure plus petite ou égale
        pct_plus_eleve <- mean(pure_portefeuille <= pure_client) * 100

        paste0(
            round(pct_plus_eleve, 1),
            " % de assurés de notre portefeuille ont une prime pure inférieure à la votre"
        )
    })

}

#------------------------------------------------
# 3. Lancement de l'application
shinyApp(ui = ui, server = server)
