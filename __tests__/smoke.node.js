/**
 * @jest-environment node
 */

require('../dist/incito');

test("it doesn't break node", () => expect(true).beTruthy);
