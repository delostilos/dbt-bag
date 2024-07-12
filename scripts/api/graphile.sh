# Run Postgraphile
# Prerequisite: NodeJS
npx postgraphile -c 'postgres://postgres@localhost/basisreg' --watch --enhance-graphiql --dynamic-json --schema bag_locatie