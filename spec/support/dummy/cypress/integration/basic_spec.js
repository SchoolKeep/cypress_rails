const host = Cypress.env("app_host");
const port = Cypress.env("app_port");

describe("Visiting the root address", () => {
  it("renders OK", () => {
    cy.visit(`http://${host}:${port}`);
    cy.title().should("equal", "Dummy app");
    cy.contains("Hello Dummy!");
  });
});
