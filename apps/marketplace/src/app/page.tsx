'use client';
import styled from 'styled-components';

const StyledPage = styled.div`
  .page {
  }
`;

export default function Index() {
  /*
   * Replace the elements below with your own.
   *
   * Note: The corresponding styles are in the ./index.styled-components file.
   */
  return (
    <StyledPage>
      <div className="wrapper">
        <div className="container">
          <div id="welcome">
            <h1>
              Welcome to the marketplace 👋
            </h1>
          </div>
        </div>
      </div>
    </StyledPage>
  );
}
