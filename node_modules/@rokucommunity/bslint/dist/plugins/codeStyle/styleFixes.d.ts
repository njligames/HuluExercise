import { BscFile, BsDiagnostic } from 'brighterscript';
import { ChangeEntry } from '../../textEdit';
export declare function extractFixes(addFixes: (file: BscFile, changes: ChangeEntry) => void, diagnostics: BsDiagnostic[]): BsDiagnostic[];
export declare function getFixes(diagnostic: BsDiagnostic): ChangeEntry;
