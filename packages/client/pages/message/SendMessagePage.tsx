import SendMessageForm from '../../components/form/SendMessageForm';
import Layout from '../../components/layout/Layout';
import RequireWallet from '../../components/layout/RequireWallet';
import { useMessengerContract } from '../../hooks/useMessengerContract';
import { useWallet } from '../../hooks/useWallet';

export default function SendMessagePage() {
  const { currentAccount, connectWallet } = useWallet();
  const { processing, sendMessage } = useMessengerContract({
    currentAccount: currentAccount,
  });

  return (
    <Layout>
      <RequireWallet
        currentAccount={currentAccount}
        connectWallet={connectWallet}
      >
        {processing ? (
          <div>processing...</div>
        ) : (
          <SendMessageForm
            sendMessage={(
              text: string,
              receiver: string,
              tokenInEther: string
            ) => {
              sendMessage({ text, receiver, tokenInEther });
            }}
          />
        )}
      </RequireWallet>
    </Layout>
  );
}
